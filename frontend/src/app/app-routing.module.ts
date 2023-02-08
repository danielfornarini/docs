import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';

const routes: Routes = [
  {
    path: '',
    pathMatch: 'full',
    redirectTo: 'documents',
  },
  {
    path: '',
    children: [
      {
        path: 'documents',
        loadChildren: () =>
          import('./docs/docs.module').then((m) => m.DocsModule),
      },
    ],
  },
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule],
})
export class AppRoutingModule {}
