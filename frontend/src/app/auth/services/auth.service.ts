import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { Document, User } from '../../core/models';
import { JSONAPIQuery, parseJSON, Response } from '../../shared/parser';
import { environment } from '../../../environments/environment';
import { HttpClient, HttpResponse } from '@angular/common/http';
import { tap } from 'rxjs/operators';

export interface RegisterDTO {
  user: {
    firstName: string;
    lastName: string;
    email: string;
    password: string;
    passwordConfirmation: string;
  };
}

export interface LoginDTO {
  user: {
    email: string;
    password: string;
  };
}

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  constructor(private http: HttpClient) {}

  get aturhorizationToken() {
    return localStorage.getItem('authentication-token');
  }

  set authorizationToken(token: string) {
    localStorage.setItem('authentication-token', token);
  }

  login(dto: LoginDTO): Observable<User> {
    return this.http
      .post<Response>(environment.endpoint + '/auth/login', dto, {
        params: { $$tag: 'login' },
        observe: 'response',
      })
      .pipe(
        tap((e: any) => {
          this.authorizationToken = e.headers.get('Authorization');
        }),
        parseJSON<User>()
      );
  }

  register(dto: RegisterDTO): Observable<User> {
    return this.http
      .post<Response>(environment.endpoint + '/auth/register', dto, {
        params: { $$tag: 'register' },
      })
      .pipe(parseJSON<User>());
  }

  confirm(confirmationToken: string): Observable<User> {
    return this.http
      .get<Response>(environment.endpoint + '/auth/confirmation', {
        params: { $$tag: 'confirm', confirmationToken },
      })
      .pipe(parseJSON<User>());
  }

  me(): Observable<User> {
    return this.http
      .get<Response>(environment.endpoint + '/users/me', {
        params: { $$tag: 'me' },
      })
      .pipe(parseJSON<User>());
  }
}
