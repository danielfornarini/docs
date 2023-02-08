import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { LoginRequest } from 'src/app/core/models';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  constructor() {}

  login(loginRequest: LoginRequest): Observable<any> {
    return of();
  }

  register(registerRequest: any): Observable<any> {
    return of();
  }
}
