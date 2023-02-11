import { Component } from '@angular/core';
import { FormControl, FormGroup, Validators } from '@angular/forms';
import { Router } from '@angular/router';
import { tap } from 'rxjs';
import { AuthService, RegisterDTO } from '../../services/auth.service';
import { PasswordMatching } from '../../validators/password-matching';

@Component({
  selector: 'app-register',
  template: `
    <div>
      <a [routerLink]="['../login']">Go to Login</a>
      <mat-card>
        <mat-card-title>Register</mat-card-title>

        <mat-card-content>
          <form [formGroup]="registerForm" (ngSubmit)="register()">
            <mat-form-field>
              <input
                type="email"
                matInput
                placeholder="Email"
                formControlName="email"
              />
              <!-- Here we can display error messages/hints for the user, if one of the Validators adds an error to the email
           with the .touched check we only display the hints if the input was touched by the users -->
              <mat-error
                *ngIf="
                  this.registerForm.get('email')?.touched &&
                  this.registerForm.get('email')?.hasError('required')
                "
              >
                Email is required</mat-error
              >
              <mat-error
                *ngIf="
                  this.registerForm.get('email')?.touched &&
                  this.registerForm.get('email')?.hasError('email')
                "
              >
                Email must be a valid Email</mat-error
              >
            </mat-form-field>

            <mat-form-field>
              <input
                type="text"
                matInput
                placeholder="First Name"
                formControlName="firstName"
              />
              <mat-error
                *ngIf="
                  this.registerForm.get('firstName')?.touched &&
                  this.registerForm.get('firstName')?.hasError('required')
                "
              >
                First Name is required</mat-error
              >
            </mat-form-field>

            <mat-form-field>
              <input
                type="text"
                matInput
                placeholder="Last Name"
                formControlName="lastName"
              />
              <mat-error
                *ngIf="
                  this.registerForm.get('lastName')?.touched &&
                  this.registerForm.get('lastName')?.hasError('required')
                "
              >
                Last Name is required</mat-error
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
                  this.registerForm.get('password')?.touched &&
                  this.registerForm.get('password')?.hasError('required')
                "
              >
                Password is required</mat-error
              >
            </mat-form-field>

            <mat-form-field>
              <input
                type="password"
                matInput
                placeholder="Password Confirmation"
                formControlName="passwordConfirmation"
              />
              <mat-error
                *ngIf="
                  this.registerForm.get('passwordConfirmation')?.touched &&
                  this.registerForm
                    .get('passwordConfirmation')
                    ?.hasError('required')
                "
              >
                Password Confirmation is required</mat-error
              >
            </mat-form-field>

            <mat-error
              *ngIf="
                this.registerForm.get('passwordConfirmation')?.dirty &&
                this.registerForm.hasError('passwordsNotMatching')
              "
            >
              Passwords are not matching!</mat-error
            >

            <div class="button">
              <!-- Button is disabled(not clickable), if our RegisterForm contains Validation Errors -->
              <button type="submit" mat-button [disabled]="!registerForm.valid">
                Register
              </button>
            </div>
          </form>
        </mat-card-content>
      </mat-card>
    </div>
  `,
  styleUrls: ['register.component.scss'],
})
export class RegisterComponent {
  registerForm = new FormGroup(
    {
      email: new FormControl<string>('', [
        Validators.required,
        Validators.email,
      ]),
      firstName: new FormControl<string>('', [Validators.required]),
      lastName: new FormControl<string>('', [Validators.required]),
      password: new FormControl<string>('', [Validators.required]),
      passwordConfirmation: new FormControl<string>('', [Validators.required]),
    },
    { validators: PasswordMatching.passwordsMatching }
  );

  constructor(private router: Router, private authService: AuthService) {}

  register(): void {
    if (!this.registerForm.valid) {
      return;
    }

    const payload = {
      user: {
        ...this.registerForm.value,
      },
    };

    this.authService
      .register(payload as RegisterDTO)
      .pipe(tap(() => this.router.navigate(['documents'])))
      .subscribe();
  }
}