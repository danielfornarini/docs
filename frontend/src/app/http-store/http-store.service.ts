import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable, Subject, throwError } from 'rxjs';
import { catchError, filter, map, tap } from 'rxjs/operators';

type PseudoPromise<K> = {
  then: (fn: (e: K) => Promise<K>) => Promise<K>;
  catch: (fn: (e: K) => Promise<K>) => Promise<K>;
};

interface ResponseData {
  readonly tag: string;
  readonly data?: any;
  readonly error?: ErrorData;
  readonly status: number;
  readonly loading: boolean;
}

interface ErrorData {
  readonly message: string;
  readonly errors: Record<string, string[]>;
  readonly details: Record<string, string[]>;
}

@Injectable({
  providedIn: 'root',
})
export class HttpStoreService {
  readonly data = new Map<string, ResponseData>();

  private readonly requestStatus = new Subject<ResponseData>();

  // private _loading = new BehaviorSubject<{ tag: string; value: boolean }>({
  //   tag: '',
  //   value: false,
  // });
  private _activeRequestsCount = new BehaviorSubject<number>(0);
  readonly activeRequestsCount$ = this._activeRequestsCount.asObservable();

  get activeRequestsCount() {
    return this._activeRequestsCount.value;
  }

  // FIXME: Experimental
  observe(...tags: string[]) {
    return this.requestStatus.pipe(
      filter((e) => tags.includes(e.tag)),
      map((e) => e.loading)
    );
  }

  isLoading(...tags: string[]) {
    return tags.some((tag) => {
      const value = this.data.get(tag);
      return value ? value.loading : false;
    });
  }

  getErrors(tag: string) {
    const value = this.data.get(tag);
    return value?.error;
  }

  wrapPromise<K, T extends Promise<K> | PseudoPromise<K>>(
    tag: string,
    promise: T
  ): T {
    this.requestStarted(tag);
    return promise
      .then((e) => {
        this.requestSuccess(tag, e);
        return Promise.resolve(e);
      })
      .catch((error) => {
        this.requestFailed(tag, error);
        return Promise.reject(error);
      }) as T;
  }

  wrap<K, T extends Observable<K>>(tag: string, obs: T): T {
    this.requestStarted(tag);
    return obs.pipe(
      filter((e: any) => e.type !== 0),
      tap((e) => this.requestSuccess(tag, e)),
      catchError((error) => {
        this.requestFailed(tag, error);
        return throwError(error);
      })
    ) as T;
  }

  requestStarted(tag: string) {
    const data = { tag, loading: true, status: 0 };
    this.data.set(tag, data);
    this.requestStatus.next(data);
    this._activeRequestsCount.next(this.activeRequestsCount + 1);
  }

  requestSuccess(tag: string, data: any) {
    const value = this.data.get(tag);
    const newData: ResponseData = value
      ? {
          ...value,
          status: 200,
          loading: false,
          data,
        }
      : { loading: false, status: 200, tag, data };

    this.data.set(tag, newData);
    this.requestStatus.next(newData);
    this.clearRequest(tag);
  }

  requestFailed(tag: string, error: any) {
    const value = this.data.get(tag);
    const newData: ResponseData = value
      ? {
          ...value,
          status: error?.status ?? 0,
          loading: false,
          error: error?.error ?? error,
        }
      : { loading: false, status: 0, tag, error };

    this.data.set(tag, newData);
    this.requestStatus.next(newData);
    this.clearRequest(tag);
  }

  private clearRequest(tag: string) {
    // this._loading.next({ tag, value: false });
    this._activeRequestsCount.next(this.activeRequestsCount - 1);
  }
}
