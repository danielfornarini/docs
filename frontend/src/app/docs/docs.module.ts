import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HomescreenComponent } from './pages/homescreen/homescreen.component';
import { DocsRoutingModule } from './docs-routing.module';
import { MatToolbarModule } from '@angular/material/toolbar';
import { MatIconModule } from '@angular/material/icon';
import { MatMenuModule } from '@angular/material/menu';
import { MatSidenavModule } from '@angular/material/sidenav';
import { MatButtonModule } from '@angular/material/button';
import { NavbarComponent } from './components/navbar/navbar.component';
import { SidebarComponent } from './components/sidebar/sidebar.component';
import { MatAutocompleteModule } from '@angular/material/autocomplete';
import { MatGridListModule } from '@angular/material/grid-list';
import { ScrollingModule } from '@angular/cdk/scrolling';
import { MatCardModule } from '@angular/material/card';
import { QuillModule } from 'ngx-quill';
import { DocumentComponent } from './pages/document/document.component';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatProgressSpinnerModule } from '@angular/material/progress-spinner';
import { DocsListComponent } from './components/docs-list/docs-list.component';
import { MatDialogModule } from '@angular/material/dialog';
import { MatInputModule } from '@angular/material/input';
import { EditTitleDialogComponent } from './components/edit-title-dialog/edit-title-dialog.component';
import { FormsModule } from '@angular/forms';
import { NewDocumentDialogComponent } from './components/new-document-dialog/new-document-dialog.component';
@NgModule({
  declarations: [
    HomescreenComponent,
    DocumentComponent,
    NavbarComponent,
    SidebarComponent,
    DocsListComponent,
    EditTitleDialogComponent,
    NewDocumentDialogComponent,
  ],
  imports: [
    CommonModule,

    //Angular Material
    FormsModule,
    MatInputModule,
    MatDialogModule,
    MatButtonModule,
    MatMenuModule,
    MatIconModule,
    MatToolbarModule,
    MatSidenavModule,
    MatGridListModule,
    MatAutocompleteModule,
    MatCardModule,
    MatFormFieldModule,
    MatProgressSpinnerModule,
    ScrollingModule,

    //Routing
    DocsRoutingModule,

    QuillModule.forRoot(),
  ],
})
export class DocsModule {}
