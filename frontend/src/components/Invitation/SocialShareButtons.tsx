import React from 'react';
import { MessageCircle, Send, Instagram, Twitter, Facebook, Link as LinkIcon, Share2 } from 'lucide-react';
import toast from 'react-hot-toast';

interface SocialShareButtonsProps {
  invitationUrl: string;
  title?: string;
  message?: string;
}

export const SocialShareButtons: React.FC<SocialShareButtonsProps> = ({
  invitationUrl,
  title = 'Davetiye',
  message = 'Size özel davetiyem!'
}) => {
  const shareText = `${message}\n\n${invitationUrl}`;

  const handleWhatsAppShare = () => {
    const whatsappUrl = `https://wa.me/?text=${encodeURIComponent(shareText)}`;
    window.open(whatsappUrl, '_blank');
  };

  const handleTelegramShare = () => {
    const telegramUrl = `https://t.me/share/url?url=${encodeURIComponent(invitationUrl)}&text=${encodeURIComponent(message)}`;
    window.open(telegramUrl, '_blank');
  };

  const handleInstagramShare = () => {
    navigator.clipboard.writeText(invitationUrl);
    toast.success('Link kopyalandı! Instagram Story veya mesajınızda paylaşabilirsiniz.', { duration: 5000 });
  };

  const handleTwitterShare = () => {
    const twitterUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(shareText)}`;
    window.open(twitterUrl, '_blank');
  };

  const handleFacebookShare = () => {
    const facebookUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(invitationUrl)}`;
    window.open(facebookUrl, '_blank');
  };

  const handleCopyLink = () => {
    navigator.clipboard.writeText(invitationUrl);
    toast.success('Davetiye linki kopyalandı!');
  };

  const handleNativeShare = async () => {
    if (navigator.share) {
      try {
        await navigator.share({
          title: title,
          text: message,
          url: invitationUrl,
        });
      } catch (error: any) {
        if (error.name !== 'AbortError') {
          console.error('Native share error:', error);
          toast.error('Paylaşım sırasında bir hata oluştu');
        }
      }
    } else {
      handleCopyLink();
    }
  };

  return (
    <div className="space-y-4">
      <div className="text-center">
        <h3 className="text-lg font-semibold text-gray-900 mb-2">Davetiyenizi Paylaşın</h3>
        <p className="text-sm text-gray-600">Davetiyenizi sevdiklerinizle paylaşmak için sosyal medya platformlarını kullanın</p>
      </div>

      <div className="grid grid-cols-2 gap-3">
        <button
          onClick={handleWhatsAppShare}
          className="flex items-center justify-center gap-2 px-4 py-3 bg-green-500 hover:bg-green-600 text-white rounded-lg transition-colors duration-200 font-medium"
        >
          <MessageCircle className="h-5 w-5" />
          WhatsApp
        </button>

        <button
          onClick={handleTelegramShare}
          className="flex items-center justify-center gap-2 px-4 py-3 bg-blue-500 hover:bg-blue-600 text-white rounded-lg transition-colors duration-200 font-medium"
        >
          <Send className="h-5 w-5" />
          Telegram
        </button>

        <button
          onClick={handleInstagramShare}
          className="flex items-center justify-center gap-2 px-4 py-3 bg-gradient-to-r from-purple-500 via-pink-500 to-orange-500 hover:from-purple-600 hover:via-pink-600 hover:to-orange-600 text-white rounded-lg transition-colors duration-200 font-medium"
        >
          <Instagram className="h-5 w-5" />
          Instagram
        </button>

        <button
          onClick={handleFacebookShare}
          className="flex items-center justify-center gap-2 px-4 py-3 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors duration-200 font-medium"
        >
          <Facebook className="h-5 w-5" />
          Facebook
        </button>

        <button
          onClick={handleTwitterShare}
          className="flex items-center justify-center gap-2 px-4 py-3 bg-gray-900 hover:bg-black text-white rounded-lg transition-colors duration-200 font-medium"
        >
          <Twitter className="h-5 w-5" />
          X (Twitter)
        </button>

        {navigator.share ? (
          <button
            onClick={handleNativeShare}
            className="flex items-center justify-center gap-2 px-4 py-3 bg-indigo-500 hover:bg-indigo-600 text-white rounded-lg transition-colors duration-200 font-medium"
          >
            <Share2 className="h-5 w-5" />
            Daha Fazla
          </button>
        ) : (
          <button
            onClick={handleCopyLink}
            className="flex items-center justify-center gap-2 px-4 py-3 bg-gray-600 hover:bg-gray-700 text-white rounded-lg transition-colors duration-200 font-medium"
          >
            <LinkIcon className="h-5 w-5" />
            Link Kopyala
          </button>
        )}
      </div>

      <div className="mt-4">
        <label className="block text-sm font-medium text-gray-700 mb-2">
          Davetiye Linki
        </label>
        <div className="flex gap-2">
          <input
            type="text"
            value={invitationUrl}
            readOnly
            className="flex-1 px-3 py-2 border border-gray-300 rounded-lg text-sm text-gray-600 bg-gray-50 focus:outline-none focus:ring-2 focus:ring-indigo-500"
          />
          <button
            onClick={handleCopyLink}
            className="px-4 py-2 bg-indigo-500 hover:bg-indigo-600 text-white rounded-lg transition-colors duration-200 flex items-center gap-2 text-sm font-medium"
          >
            <LinkIcon className="h-4 w-4" />
            Kopyala
          </button>
        </div>
      </div>
    </div>
  );
};

export default SocialShareButtons;

