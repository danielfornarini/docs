export interface Document {
  id: number;
  title: string;
  created_at?: number;
  updated_at?: number;
}

export interface LoginRequest {
  email: string;
  password: string;
}
