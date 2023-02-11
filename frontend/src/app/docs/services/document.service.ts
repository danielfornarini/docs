import { Injectable } from '@angular/core';
import { Document, DocumentDTO } from 'src/app/core/models';
import {
  JSONAPIListQuery,
  JSONAPIQuery,
  parseJSON,
  parseListWithMeta,
  Response,
} from '../../shared/parser';
import { HttpClient } from '@angular/common/http';
import { environment } from '../../../environments/environment';

@Injectable({
  providedIn: 'root',
})
export class DocumentService {
  constructor(private http: HttpClient) {}

  getDocuments(query: JSONAPIListQuery = {}) {
    return this.http
      .get<Response>(environment.endpoint + `/documents`, {
        params: { $$tag: 'get-documents', ...query },
      })
      .pipe(parseListWithMeta<Document>());
  }

  getDocument(id: string | number, query: JSONAPIQuery = {}) {
    return this.http
      .get<Response>(environment.endpoint + `/documents/${id}`, {
        params: { $$tag: 'get-document', ...query },
      })
      .pipe(parseJSON<Document>());
  }

  createDocument(dto: Nullable<Document>, query: JSONAPIQuery = {}) {
    return this.http
      .post<Response>(environment.endpoint + `/documents`, dto, {
        params: { $$tag: 'create-document', ...query },
      })
      .pipe(parseJSON<Document>());
  }

  updateDocument(
    id: string | number,
    dto: Nullable<DocumentDTO>,
    query: JSONAPIQuery = {}
  ) {
    return this.http
      .put<Response>(environment.endpoint + `/documents/${id}`, dto, {
        params: { $$tag: 'update-document', ...query },
      })
      .pipe(parseJSON<Document>());
  }

  destroyDocument(id: string | number, query: JSONAPIQuery = {}) {
    return this.http
      .delete<Response>(environment.endpoint + `/documents/${id}`, {
        params: { $$tag: 'destroy-document', ...query },
      })
      .pipe(parseJSON<Document>());
  }
}
