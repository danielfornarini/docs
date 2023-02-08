import { ChangeDetectionStrategy, Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-sidebar',
  template: ` <p>sidebar works!</p> `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class SidebarComponent implements OnInit {
  constructor() {
    /* no-op */
  }

  ngOnInit(): void {}
}
