import { Injectable } from '@angular/core';
import {
  HttpRequest,
  HttpHandler,
  HttpEvent,
  HttpInterceptor,
} from '@angular/common/http';
import { Observable } from 'rxjs';
import { HttpStoreService } from './http-store.service';
import { tap } from 'rxjs/operators';

export const REQUEST_TAG = '$$tag';

@Injectable({
  providedIn: 'root',
})
export class HttpCollectorInterceptor implements HttpInterceptor {
  constructor(private httpStore: HttpStoreService) {}

  intercept(
    request: HttpRequest<unknown>,
    next: HttpHandler
  ): Observable<HttpEvent<unknown>> {
    const tag = request.params.get(REQUEST_TAG);

    if (tag) {
      const newRequest = request.clone({
        params: request.params.delete(REQUEST_TAG),
      });

      return this.httpStore.wrap(tag, next.handle(newRequest));
    } else {
      return next.handle(request);
    }
  }
}
