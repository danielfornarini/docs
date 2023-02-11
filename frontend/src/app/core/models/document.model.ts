import { Attr, Model, JSONAPI, DTO, Rel } from '@monade/json-api-parser';
import { User } from './user.model';

@JSONAPI('documents')
export class Document extends Model {
  @Attr() title!: string;
  @Attr() contentId!: number;
  @Attr() createdAt!: string;
  @Attr() updatedAt!: string;

  @Rel() owner!: User;
}

export type DocumentDTO = DTO<Document>;
