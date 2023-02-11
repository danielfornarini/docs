import { Component } from '@angular/core';
import { ActivatedRoute, Params, Router } from '@angular/router';
import { switchMap } from 'rxjs';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-confirm',
  template: ``,
  styles: [],
})
export class ConfirmComponent {
  constructor(
    private activatedRoute: ActivatedRoute,
    private authService: AuthService,
    private router: Router
  ) {
    this.activatedRoute.queryParams
      .pipe(
        switchMap((params: any) => {
          const confirmationToken = params.confirmation_token;

          return this.authService.confirm(confirmationToken);
        })
      )
      .subscribe((user) => {
        if (user) {
          this.router.navigate(['documents']);
        }
      });
  }
}
