import { Attr, Model, JSONAPI, DTO } from '@monade/json-api-parser';

@JSONAPI('contents')
export class Content extends Model {
  @Attr() text!: string;
  @Attr() documentId!: number;
}

export type ContentDTO = DTO<Content>;
