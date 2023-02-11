import { Injectable } from '@angular/core';
import {
  ActivatedRouteSnapshot,
  CanActivate,
  Router,
  RouterStateSnapshot,
  UrlTree,
} from '@angular/router';
import { mergeMap, Observable, of } from 'rxjs';
import { User } from '../core/models';
import { catchError } from 'rxjs/operators';
import { AuthService } from './services/auth.service';
import { UserService } from '../core/services/user.service';

@Injectable({
  providedIn: 'root',
})
export class NoAuthGuard implements CanActivate {
  constructor(private userService: UserService, private router: Router) {}

  canActivate(
    route: ActivatedRouteSnapshot,
    state: RouterStateSnapshot
  ):
    | Observable<boolean | UrlTree>
    | Promise<boolean | UrlTree>
    | boolean
    | UrlTree {
    return this.userService.me().pipe(
      mergeMap((me: User) => {
        this.router.navigate(['']);
        return of(false);
      }),
      catchError((e: any) => {
        return of(true);
      })
    );
  }
}