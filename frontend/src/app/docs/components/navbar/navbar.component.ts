import {
  ChangeDetectionStrategy,
  Component,
  EventEmitter,
  Input,
  OnInit,
  Output,
} from '@angular/core';

@Component({
  selector: 'app-navbar',
  template: `
    <mat-toolbar class="dev-toolbar bg-white">
      <div class="flex justify-between w-full">
        <div class="flex items-center w-52">
          <button
            mat-icon-button
            class="toggle-sidebar"
            (click)="toggleSidebar.emit()"
          >
            <mat-icon class="dev-toolbar_icon">{{
              sidebarOpened ? 'menu_open' : 'menu'
            }}</mat-icon>
          </button>

          <img
            src="assets/images/document.png"
            alt=""
            aria-hidden="true"
            role="presentation"
            style="width:40px;height:40px"
          />
          <span class="ml-2 text-xl font-normal dev-toolbar_title"
            >Documenti</span
          >
        </div>

        <div class="flex items-center content-center">
          <p>Autocomplete</p>
        </div>
        <div class="Account w-52 flex items-center justify-end mr-4">
          <mat-icon class="dev-toolbar_avatar">account_circle</mat-icon>
        </div>
      </div>
    </mat-toolbar>
  `,
  changeDetection: ChangeDetectionStrategy.OnPush,
})
export class NavbarComponent implements OnInit {
  @Input() sidebarOpened: boolean = false;

  @Output() toggleSidebar: EventEmitter<any> = new EventEmitter();

  constructor() {
    /* no-op */
  }

  ngOnInit(): void {}
}
