import { Component } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { tap } from 'rxjs';
import { AuthService } from '../../services/auth.service';

@Component({
  selector: 'app-login',
  template: `
    <div>
      <a [routerLink]="['../register']">Go to Register</a>
      <mat-card>
        <mat-card-title>Login</mat-card-title>
        <mat-card-content>
          <form [formGroup]="loginForm" (ngSubmit)="login()">
            <mat-form-field>
              <input
                type="email"
                matInput
                placeholder="Email"
                formControlName="email"
              />
              <mat-error
                *ngIf="
                  this.loginForm.get('email')?.touched &&
                  this.loginForm.get('email')?.hasError('required')
                "
              >
                Email is required</mat-error
              >
              <mat-error
                *ngIf="
                  this.loginForm.get('email')?.touched &&
                  this.loginForm.get('email')?.hasError('email')
                "
              >
                Email must be a valid Email</mat-error
              >
            </mat-form-field>

            <mat-form-field>
              <input
                type="password"
                matInput
                placeholder="Password"
                formControlName="password"
              />
              <mat-error
                *ngIf="
                  this.loginForm.get('password')?.touched &&
                  this.loginForm.get('password')?.hasError('required')
                "
              >
                Password is required</mat-error
              >
            </mat-form-field>

            <div class="button">
              <button type="submit" mat-button [disabled]="!loginForm.valid">
                Login
              </button>
            </div>
          </form>
        </mat-card-content>
      </mat-card>
    </div>
  `,
  styleUrls: ['login.component.scss'],
})
export class LoginComponent {
  loginForm: FormGroup = new FormGroup({
    email: new FormControl(null, [Validators.required, Validators.email]),
    password: new FormControl(null, [Validators.required]),
  });

  constructor(private authService: AuthService, private router: Router) {}

  login(): void {
    if (!this.loginForm.valid) {
      return;
    }
    this.authService
      .login(this.loginForm.value)
      .pipe(tap(() => this.router.navigate(['documents'])))
      .subscribe();
  }
}
