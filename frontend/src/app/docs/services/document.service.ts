import { Injectable } from '@angular/core';
import {
  concatMap,
  filter,
  first,
  firstValueFrom,
  Observable,
  of,
  timer,
} from 'rxjs';
import { Document } from 'src/app/core/models';

@Injectable({
  providedIn: 'root',
})
export class DocumentService {
  private mock: Document[] = [
    { id: 1, title: 'Documento 1', updated_at: 1 },
    { id: 2, title: 'Document di test', updated_at: 1 },
    { id: 3, title: 'Tesi di laurea', updated_at: 1 },
  ];

  constructor() {}

  public getDocuments(): Observable<Document[]> {
    const source = of(this.mock);

    return timer(1000).pipe(concatMap(() => source));
  }

  public getDocument(documentId: number): Observable<Document> {
    return of(this.mock.filter((element) => element.id === documentId)[0]);
  }
}
