import { TestBed } from '@angular/core/testing';

import { HttpStoreService } from './http-store.service';

describe('HttpStoreService', () => {
  let service: HttpStoreService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(HttpStoreService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
