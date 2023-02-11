import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  CanActivate,
  Router,
  RouterStateSnapshot,
  UrlTree,
} from '@angular/router';
import { mergeMap, Observable, of } from 'rxjs';
import { AuthService } from './services/auth.service';
import { catchError, tap } from 'rxjs/operators';
import { User } from '../core/models';

@Injectable({
  providedIn: 'root',
})
export class AuthGuard implements CanActivate {
  constructor(private authService: AuthService, private router: Router) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ):
    | Observable<boolean | UrlTree>
    | Promise<boolean | UrlTree>
    | boolean
    | UrlTree {
    return this.authService.me().pipe(
      mergeMap((me: User) => {
        return of(true);
      }),
      catchError((e: any) => {
        this.router.navigate(['auth', 'login']);
        return of(false);
      })
    );
  }
}
