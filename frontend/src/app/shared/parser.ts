import { map } from 'rxjs/operators';
import { Parser, JSONDataWithMeta } from '@monade/json-api-parser';
export { JSONAPI, JSONModel } from '@monade/json-api-parser';

type PaginationMeta = any;

export interface JSONAPIQuery {
  include?: string;
  [key: `fields[${string}]`]: string | undefined;
}

export interface JSONAPIListQuery extends JSONAPIQuery {
  [key: `filter[${string}]`]: string | number | undefined;
  'page[number]'?: string | number;
  'page[size]'?: string | number;
  sort?: string;
}

export interface Response extends JSONDataWithMeta<PaginationMeta> {}

export function parseJSON<T>() {
  return map((e: Response) => new Parser(e.data, e.included).run<T>() as T);
}

export function parseListWithMeta<T>() {
  return map((e: Response) => {
    const data = new Parser(e.data, e.included).run<T[]>() as T[];
    const meta = e.meta;
    return { data, meta };
  });
}
