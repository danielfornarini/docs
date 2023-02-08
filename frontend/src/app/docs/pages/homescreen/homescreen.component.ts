import { Component, Input, OnInit } from '@angular/core';
import { MatDialog, MatDialogConfig } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { Document } from 'src/app/core/models';
import { EditTitleDialogComponent } from '../../components/edit-title-dialog/edit-title-dialog.component';
import { NewDocumentDialogComponent } from '../../components/new-document-dialog/new-document-dialog.component';
import { DocumentService } from '../../services/document.service';

@Component({
  selector: 'app-homescreen',
  templateUrl: 'homescreen.component.html',
  styleUrls: ['homescreen.component.scss'],
})
export class HomescreenComponent implements OnInit {
  documents: Document[] = [];
  sidebarOpened: boolean = false;
  isLoading: boolean = true;

  constructor(
    private route: Router,
    public dialog: MatDialog,
    private documentService: DocumentService
  ) {}

  ngOnInit(): void {
    this.documentService.getDocuments().subscribe((res: Document[]) => {
      this.documents = res;
      this.isLoading = false;
    });
  }

  toggleSidebar(): void {
    this.sidebarOpened = !this.sidebarOpened;
  }

  newDocument(): void {
    const config: MatDialogConfig = new MatDialogConfig();
    config.disableClose = true;
    config.autoFocus = true;
    config.data = {};
    this.dialog
      .open(NewDocumentDialogComponent, config)
      .afterClosed()
      .subscribe((result) => {
        console.log('The dialog was closed');
      });
  }

  editDocument(document: Document): void {
    this.route.navigate(['documents', document.id]);
  }

  renameDocument(document: Document) {
    const config: MatDialogConfig = new MatDialogConfig();
    config.disableClose = true;
    config.autoFocus = true;
    config.data = document;
    this.dialog
      .open(EditTitleDialogComponent, config)
      .afterClosed()
      .subscribe((result) => {
        console.log('The dialog was closed');
      });
  }
}
