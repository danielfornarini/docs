import {
  HttpEvent,
  HttpInterceptor,
  HttpHandler,
  HttpRequest,
} from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable, of } from 'rxjs';
import { mergeMap, tap } from 'rxjs/operators';
import { AuthService } from './services/auth.service';

@Injectable()
export class AuthInterceptor implements HttpInterceptor {
  constructor(private authService: AuthService) {}

  intercept(
    request: HttpRequest<any>,
    next: HttpHandler
  ): Observable<HttpEvent<any>> {
    return of(this.authService.aturhorizationToken).pipe(
      mergeMap((token) => {
        if (token) {
          request = request.clone({
            headers: request.headers.set('Authorization', token),
          });
        }
        return next.handle(request);
      })
    );
  }
}
