import { Attr, Model, JSONAPI, DTO } from '@monade/json-api-parser';

@JSONAPI('users')
export class User extends Model {
  @Attr() firstName!: string;
  @Attr() lastName!: string;
  @Attr() email!: string;
  @Attr() profileImage!: string;
}

export type UserDTO = DTO<User>;
