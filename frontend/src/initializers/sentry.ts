import * as Sentry from '@sentry/angular';
import { BrowserTracing } from '@sentry/tracing';
import { environment } from '../environments/environment';

if (environment.sentryDSN) {
  Sentry.init({
    dsn: environment.sentryDSN,
    integrations: [
      new BrowserTracing({
        routingInstrumentation: Sentry.routingInstrumentation,
      }),
    ],
    tracesSampleRate: 1.0,
  });
}
