export type ComplaintCategory =
  | '가격정보'
  | '상품정보'
  | '배송구매'
  | '리뷰평점'
  | '회원개인정보'
  | '시스템기술';

export type Priority = 'high' | 'medium' | 'low';

export type Urgency = 'urgent' | 'normal' | 'low';

export interface CreateComplaintRequest {
  customerName: string;
  customerEmail: string;
  customerPhone?: string;
  category: ComplaintCategory;
  subCategory?: string;
  priority: Priority;
  urgency: Urgency;
  subject: string;
  description: string;
  attachments?: string[];
  relatedProductId?: string;
  relatedOrderId?: string;
}

export interface ComplaintResponse {
  id: string;
  ticketNumber: string;
  userId?: string;
  customerName: string;
  customerEmail: string;
  customerPhone?: string;
  category: ComplaintCategory;
  subCategory?: string;
  priority: Priority;
  urgency: Urgency;
  subject: string;
  description: string;
  status: string;
  relatedProductId?: string;
  relatedOrderId?: string;
  createdAt: string;
  updatedAt: string;
}
