import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpStoreService } from './http-store.service';
import { HttpCollectorInterceptor } from './http-collector.interceptor';

@NgModule({
  declarations: [],
  providers: [
    HttpStoreService,
    // HttpCollectorInterceptor
  ],
  imports: [CommonModule],
})
export class HttpStoreModule {}
