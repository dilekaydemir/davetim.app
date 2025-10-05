/**
 * Form validation utilities
 */

export interface ValidationResult {
  isValid: boolean;
  error?: string;
}

/**
 * Email validation
 */
export function validateEmail(email: string): ValidationResult {
  if (!email || email.trim() === '') {
    return { isValid: false, error: 'E-posta adresi gerekli' };
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    return { isValid: false, error: 'Geçerli bir e-posta adresi girin' };
  }

  return { isValid: true };
}

/**
 * Password validation
 */
export function validatePassword(password: string): ValidationResult {
  if (!password || password.trim() === '') {
    return { isValid: false, error: 'Şifre gerekli' };
  }

  if (password.length < 6) {
    return { isValid: false, error: 'Şifre en az 6 karakter olmalı' };
  }

  return { isValid: true };
}

/**
 * Required field validation
 */
export function validateRequired(value: string, fieldName: string = 'Bu alan'): ValidationResult {
  if (!value || value.trim() === '') {
    return { isValid: false, error: `${fieldName} gerekli` };
  }

  return { isValid: true };
}

/**
 * Phone number validation (Turkish format)
 */
export function validatePhone(phone: string): ValidationResult {
  if (!phone || phone.trim() === '') {
    return { isValid: true }; // Optional field
  }

  // Remove spaces and dashes
  const cleanPhone = phone.replace(/[\s-]/g, '');

  // Turkish phone format: 5XXXXXXXXX or +905XXXXXXXXX
  const phoneRegex = /^(\+?90)?5\d{9}$/;
  if (!phoneRegex.test(cleanPhone)) {
    return { isValid: false, error: 'Geçerli bir telefon numarası girin (05XX XXX XX XX)' };
  }

  return { isValid: true };
}

/**
 * Date validation (must be in the future)
 */
export function validateFutureDate(date: string): ValidationResult {
  if (!date || date.trim() === '') {
    return { isValid: true }; // Optional field
  }

  const selectedDate = new Date(date);
  const today = new Date();
  today.setHours(0, 0, 0, 0);

  if (selectedDate < today) {
    return { isValid: false, error: 'Tarih bugünden önce olamaz' };
  }

  return { isValid: true };
}

/**
 * Format phone number as user types
 */
export function formatPhoneNumber(value: string): string {
  // Remove all non-numeric characters
  const numbers = value.replace(/\D/g, '');

  // Format as: 0XXX XXX XX XX
  if (numbers.length <= 4) {
    return numbers;
  } else if (numbers.length <= 7) {
    return `${numbers.slice(0, 4)} ${numbers.slice(4)}`;
  } else if (numbers.length <= 9) {
    return `${numbers.slice(0, 4)} ${numbers.slice(4, 7)} ${numbers.slice(7)}`;
  } else {
    return `${numbers.slice(0, 4)} ${numbers.slice(4, 7)} ${numbers.slice(7, 9)} ${numbers.slice(9, 11)}`;
  }
}

/**
 * Debounce function for validation
 */
export function debounce<T extends (...args: any[]) => any>(
  func: T,
  wait: number
): (...args: Parameters<T>) => void {
  let timeout: NodeJS.Timeout | null = null;

  return (...args: Parameters<T>) => {
    if (timeout) clearTimeout(timeout);
    timeout = setTimeout(() => func(...args), wait);
  };
}

