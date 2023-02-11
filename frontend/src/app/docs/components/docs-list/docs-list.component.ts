import {
  ChangeDetectionStrategy,
  Component,
  EventEmitter,
  Input,
  Output,
} from '@angular/core';
import { Document } from 'src/app/core/models';

@Component({
  selector: 'app-docs-list',
  template: `
    <mat-spinner *ngIf="isLoading" diameter="50" class="mx-auto"></mat-spinner>
    <cdk-virtual-scroll-viewport
      itemSize="70"
      class="example-viewport"
      [style.height]="7 * 70 + 'px'"
      *ngIf="!isLoading"
    >
      <div
        *cdkVirtualFor="let document of documents"
        style="height: 70px;display: flex;flex-direction: row;align-items: center;"
      >
        <div class="document-item" (click)="editDocument.emit(document)">
          <img
            class="document-item_thumb"
            src="assets/images/document.png"
            alt="document"
          />
          <p style="width: -webkit-fill-available;">{{ document.title }}</p>
          <p style="width: 30%;">io</p>
          <p style="width: 30%;">{{ document.updated_at }}</p>
          <div class="document-item_actions">
            <button
              mat-icon-button
              [matMenuTriggerFor]="mainMenu"
              (click)="stopPropagation($event)"
            >
              <mat-icon>more_vert</mat-icon>
            </button>
            <mat-menu #mainMenu="matMenu" xPosition="after" yPosition="below">
              <button mat-menu-item (click)="renameDocument.emit(document)">
                <mat-icon>edit_outline</mat-icon>
                Rinomina
              </button>
              <button mat-menu-item (click)="deleteDocument.emit(document)">
                <mat-icon>delete_outline</mat-icon>
                Rimuovi
              </button>
            </mat-menu>
          </div>
        </div>
      </div>
    </cdk-virtual-scroll-viewport>
  `,
  styleUrls: ['./docs-list.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class DocsListComponent {
  @Input() documents: Document[] = [];
  @Input() isLoading: boolean = false;

  @Output() editDocument: EventEmitter<Document> = new EventEmitter<Document>();
  @Output() renameDocument: EventEmitter<Document> =
    new EventEmitter<Document>();
  @Output() deleteDocument: EventEmitter<Document> =
    new EventEmitter<Document>();

  constructor() {
    /* no-op */
  }

  stopPropagation(event: MouseEvent) {
    event.stopPropagation();
  }
}
