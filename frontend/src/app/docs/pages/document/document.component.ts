import { Component, OnInit, ViewEncapsulation } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, ParamMap, Router } from '@angular/router';
import { isNaN } from '@sentry/utils';
import { of, switchMap } from 'rxjs';
import { Document } from 'src/app/core/models';
import { DocumentService } from '../../services/document.service';

@Component({
  selector: 'app-document',
  template: `
    <div>
      <div class="flex items-center p-4">
        <img src="assets/images/document.png" />
        <div>
          <p>{{ document.title }}</p>
          <p class="text-sm text-gray-600">
            Ultima modifica: {{ document.createdAt || '-' }}
          </p>
        </div>
        <div class="ml-auto">
          <button mat-icon-button>
            <mat-icon class="align-top">history</mat-icon>
          </button>
        </div>
      </div>
      <div class="editor-container">
        <quill-editor
          theme="snow"
          placeholder=""
          style="width: 100%;"
        ></quill-editor>
      </div>
    </div>
  `,
  styleUrls: ['./document.component.scss'],
  encapsulation: ViewEncapsulation.None,
})
export class DocumentComponent implements OnInit {
  document!: Document;

  modules = {
    formula: true,
    toolbar: [
      ['bold', 'italic', 'underline', 'strike'], // toggled buttons
      ['blockquote', 'code-block'],

      [{ header: 1 }, { header: 2 }], // custom button values
      [{ list: 'ordered' }, { list: 'bullet' }],
      [{ script: 'sub' }, { script: 'super' }], // superscript/subscript
      [{ indent: '-1' }, { indent: '+1' }], // outdent/indent
      [{ direction: 'rtl' }], // text direction

      [{ size: ['small', false, 'large', 'huge'] }], // custom dropdown
      [{ header: [1, 2, 3, 4, 5, 6, false] }],

      [{ color: [] }, { background: [] }], // dropdown with defaults from theme
      [{ font: [] }],
      [{ align: [] }],

      ['clean'], // remove formatting button

      ['link', 'image', 'video'],
    ],
  };

  constructor(
    private router: Router,
    public dialog: MatDialog,
    private activatedRoute: ActivatedRoute,
    private documentService: DocumentService
  ) {
    /* no-op */
  }

  ngOnInit(): void {
    this.activatedRoute.paramMap
      .pipe(
        switchMap((u: ParamMap) => {
          const id = u.get('id');
          if (!id || isNaN(id)) {
            return of(null);
          }
          const documnetId: number = parseInt(id);
          return this.documentService.getDocument(documnetId);
        })
      )
      .subscribe((document: Document | null) => {
        if (document) {
          this.document = document;
        } else {
          this.router.navigate(['documents']);
        }
      });
  }
}
