import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { JSONAPIQuery, parseJSON, Response } from 'src/app/shared/parser';
import { environment } from 'src/environments/environment';
import { User, UserDTO } from '../models';

@Injectable({
  providedIn: 'root',
})
export class UserService {
  constructor(private httpClient: HttpClient) {}

  updateDocument(
    id: string | number,
    dto: Nullable<UserDTO>,
    query: JSONAPIQuery = {}
  ) {
    return this.httpClient
      .put<Response>(environment.endpoint + `/users/${id}`, dto, {
        params: { $$tag: 'update-user', ...query },
      })
      .pipe(parseJSON<User>());
  }

  destroyDocument(id: string | number, query: JSONAPIQuery = {}) {
    return this.httpClient
      .delete<Response>(environment.endpoint + `/users/${id}`, {
        params: { $$tag: 'destroy-user', ...query },
      })
      .pipe(parseJSON<User>());
  }

  me(): Observable<User> {
    return this.httpClient
      .get<Response>(environment.endpoint + '/users/me', {
        params: { $$tag: 'me' },
      })
      .pipe(parseJSON<User>());
  }
}
