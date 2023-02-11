import { AbstractControl, ValidationErrors } from '@angular/forms';

export class PasswordMatching {
  static passwordsMatching(control: AbstractControl): ValidationErrors | null {
    const password = control.get('password')?.value;
    const passwordConfirmation = control.get('passwordConfirmation')?.value;

    // Check if passwords are matching. If not then add the error 'passwordsNotMatching: true' to the form
    if (
      password === passwordConfirmation &&
      password !== null &&
      passwordConfirmation !== null
    ) {
      return null;
    } else {
      return { passwordsNotMatching: true };
    }
  }
}
