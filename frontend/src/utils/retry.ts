/**
 * Retry utility for handling network failures
 */

export interface RetryOptions {
  maxRetries?: number;
  delayMs?: number;
  backoff?: boolean;
  onRetry?: (attempt: number, error: Error) => void;
}

const DEFAULT_OPTIONS: Required<RetryOptions> = {
  maxRetries: 3,
  delayMs: 1000,
  backoff: true,
  onRetry: () => {},
};

/**
 * Retry a function with exponential backoff
 */
export async function retry<T>(
  fn: () => Promise<T>,
  options: RetryOptions = {}
): Promise<T> {
  const opts = { ...DEFAULT_OPTIONS, ...options };
  let lastError: Error;

  for (let attempt = 1; attempt <= opts.maxRetries; attempt++) {
    try {
      return await fn();
    } catch (error: any) {
      lastError = error;
      
      // Don't retry on client errors (4xx)
      if (error.status >= 400 && error.status < 500) {
        throw error;
      }

      // Don't retry on last attempt
      if (attempt === opts.maxRetries) {
        throw error;
      }

      // Calculate delay with exponential backoff
      const delay = opts.backoff 
        ? opts.delayMs * Math.pow(2, attempt - 1)
        : opts.delayMs;

      opts.onRetry(attempt, error);

      // Wait before retrying
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }

  throw lastError!;
}

/**
 * Check if error is a network error
 */
export function isNetworkError(error: any): boolean {
  return (
    error.message?.includes('fetch') ||
    error.message?.includes('network') ||
    error.message?.includes('NetworkError') ||
    error.name === 'NetworkError' ||
    error.code === 'NETWORK_ERROR'
  );
}

/**
 * Get user-friendly error message
 */
export function getUserFriendlyErrorMessage(error: any): string {
  // Network errors
  if (isNetworkError(error)) {
    return 'İnternet bağlantısı kontrol edilemiyor. Lütfen bağlantınızı kontrol edin.';
  }

  // Timeout errors
  if (error.code === 'ETIMEDOUT' || error.message?.includes('timeout')) {
    return 'İstek zaman aşımına uğradı. Lütfen tekrar deneyin.';
  }

  // Server errors (5xx)
  if (error.status >= 500) {
    return 'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyin.';
  }

  // Authentication errors
  if (error.status === 401) {
    return 'Oturumunuz sonlanmış. Lütfen tekrar giriş yapın.';
  }

  // Permission errors
  if (error.status === 403) {
    return 'Bu işlem için yetkiniz yok.';
  }

  // Not found errors
  if (error.status === 404) {
    return 'İstenen kaynak bulunamadı.';
  }

  // Rate limiting
  if (error.status === 429) {
    return 'Çok fazla istek gönderdiniz. Lütfen bir süre bekleyin.';
  }

  // Default to error message or generic message
  return error.message || 'Bir hata oluştu. Lütfen tekrar deneyin.';
}

