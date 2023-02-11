import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { DocumentComponent } from './pages/document/document.component';
import { HomescreenComponent } from './pages/homescreen/homescreen.component';

const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    component: HomescreenComponent,
  },
  {
    path: ':id',
    pathMatch: 'full',
    component: DocumentComponent,
  },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
})
export class DocsRoutingModule {}
