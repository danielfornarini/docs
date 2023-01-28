import { createRoutingFactory, Spectator } from '@ngneat/spectator';
import { AppComponent } from './app.component';

describe('AppComponent', () => {
  let spectator: Spectator<AppComponent>;

  const createComponent = createRoutingFactory({
    component: AppComponent,
    shallow: true,
  });

  beforeEach(async () => {
    spectator = createComponent();
  });

  it('should create the app', () => {
    expect(spectator.component).toBeTruthy();
  });

  it(`should have as title 'sample'`, () => {
    expect(spectator.component.title).toEqual('sample');
  });
});
