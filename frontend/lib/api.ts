import { CreateComplaintRequest, ComplaintResponse } from '@/types/complaint';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3003';

export class ApiError extends Error {
  constructor(
    public status: number,
    message: string
  ) {
    super(message);
    this.name = 'ApiError';
  }
}

export async function createComplaint(
  data: CreateComplaintRequest
): Promise<ComplaintResponse> {
  const response = await fetch(`${API_URL}/complaints`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify(data),
  });

  if (!response.ok) {
    const errorData = await response.json().catch(() => ({
      message: 'Failed to create complaint',
    }));
    throw new ApiError(
      response.status,
      errorData.message || 'Failed to create complaint'
    );
  }

  return response.json();
}

export async function getComplaint(id: string): Promise<ComplaintResponse> {
  const response = await fetch(`${API_URL}/complaints/${id}`);

  if (!response.ok) {
    throw new ApiError(response.status, 'Failed to fetch complaint');
  }

  return response.json();
}
