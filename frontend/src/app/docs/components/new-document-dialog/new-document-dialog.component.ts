import { ChangeDetectionStrategy, Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'app-edit-title-dialog',
  template: `
    <h1 mat-dialog-title>Nuovo documento</h1>
    <div mat-dialog-content>
      <p>Immetti un nuovo nome per l'elemento:</p>
      <mat-form-field appearance="fill">
        <input matInput [(ngModel)]="data.title" />
      </mat-form-field>
    </div>
    <div mat-dialog-actions align="end">
      <button mat-flat-button (click)="close()">Anulla</button>
      <button
        mat-flat-button
        color="primary"
        [mat-dialog-close]="data.title"
        cdkFocusInitial
      >
        Conferma
      </button>
    </div>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class NewDocumentDialogComponent {
  constructor(
    public dialogRef: MatDialogRef<NewDocumentDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Document
  ) {
    /* no-op */
  }

  close(): void {
    this.dialogRef.close();
  }
}
