import { Attr, Model, JSONAPI, DTO, Rel } from '@monade/json-api-parser';
import { Content } from './content.model';
import { User } from './user.model';

@JSONAPI('contentVersions')
export class ContentVersion extends Model {
  @Attr() content!: Content;
  @Attr() createdAt!: string;

  @Rel() user!: User;
}

export type ContentVersionDTO = DTO<ContentVersion>;
