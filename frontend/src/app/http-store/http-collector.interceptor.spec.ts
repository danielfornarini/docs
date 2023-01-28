import { TestBed } from '@angular/core/testing';

import { HttpCollectorInterceptor } from './http-collector.interceptor';

describe('HttpCollectorInterceptor', () => {
  beforeEach(() =>
    TestBed.configureTestingModule({
      providers: [HttpCollectorInterceptor],
    })
  );

  it('should be created', () => {
    const interceptor: HttpCollectorInterceptor = TestBed.inject(
      HttpCollectorInterceptor
    );
    expect(interceptor).toBeTruthy();
  });
});
