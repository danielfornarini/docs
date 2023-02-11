import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';

@Injectable({
  providedIn: 'root',
})
export class AuthService {
  constructor() {}

  login(loginRequest: any): Observable<any> {
    return of();
  }

  register(registerRequest: any): Observable<any> {
    return of();
  }
}
