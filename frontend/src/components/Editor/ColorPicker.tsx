import React, { useState } from 'react';
// @ts-ignore - react-color type definition issue
import { SketchPicker, ColorResult } from 'react-color';
import { Palette, X } from 'lucide-react';
import { colorPresets, categories, type ColorPreset } from '../../utils/colorPresets';

interface ColorPickerProps {
  colors: {
    primary: string;
    secondary: string;
    background: string;
    text: string;
    accent: string;
  };
  onChange: (colors: ColorPickerProps['colors']) => void;
  defaultColors?: {
    primary: string;
    secondary: string;
    background: string;
    text: string;
    accent: string;
  };
}

const ColorPicker: React.FC<ColorPickerProps> = ({ colors, onChange, defaultColors }) => {
  const [activeColor, setActiveColor] = useState<keyof ColorPickerProps['colors'] | null>(null);
  const [selectedCategory, setSelectedCategory] = useState<string>('wedding');

  const handleColorChange = (color: ColorResult) => {
    if (activeColor) {
      onChange({
        ...colors,
        [activeColor]: color.hex
      });
    }
  };

  const handlePresetSelect = (preset: ColorPreset) => {
    onChange(preset.colors);
    setActiveColor(null);
  };

  const colorLabels = {
    primary: 'Ana Renk',
    secondary: 'İkincil Renk',
    background: 'Arka Plan',
    text: 'Metin Rengi',
    accent: 'Vurgu Rengi'
  };

  return (
    <div className="bg-white rounded-lg shadow p-6">
      <div className="flex items-center gap-2 mb-6">
        <Palette className="h-5 w-5 text-primary-600" />
        <h3 className="text-lg font-semibold text-gray-900">Renk Özelleştirme</h3>
      </div>

      {/* Preset Categories */}
      <div className="mb-6">
        <h4 className="text-sm font-medium text-gray-700 mb-3">Hazır Temalar</h4>
        <div className="flex flex-wrap gap-2 mb-4">
          {categories.map((category) => (
            <button
              key={category.id}
              onClick={() => setSelectedCategory(category.id)}
              className={`px-3 py-2 text-sm rounded-lg border transition-colors ${
                selectedCategory === category.id
                  ? 'bg-primary-50 border-primary-500 text-primary-700'
                  : 'bg-white border-gray-300 text-gray-700 hover:border-primary-300'
              }`}
            >
              {category.emoji} {category.name}
            </button>
          ))}
        </div>

        {/* Preset Grid */}
        <div className="grid grid-cols-2 gap-3 max-h-64 overflow-y-auto">
          {colorPresets
            .filter(preset => preset.category === selectedCategory)
            .map((preset) => (
              <button
                key={preset.id}
                onClick={() => handlePresetSelect(preset)}
                className="p-3 border border-gray-200 rounded-lg hover:border-primary-500 hover:shadow-md transition-all text-left"
              >
                <div className="flex items-center gap-2 mb-2">
                  <div className="flex gap-1">
                    <div
                      className="w-6 h-6 rounded-full border border-gray-300"
                      style={{ backgroundColor: preset.colors.primary }}
                    />
                    <div
                      className="w-6 h-6 rounded-full border border-gray-300"
                      style={{ backgroundColor: preset.colors.secondary }}
                    />
                    <div
                      className="w-6 h-6 rounded-full border border-gray-300"
                      style={{ backgroundColor: preset.colors.accent }}
                    />
                  </div>
                </div>
                <p className="text-xs font-medium text-gray-700">{preset.name}</p>
              </button>
            ))}
        </div>
      </div>

      {/* Custom Colors */}
      <div>
        <h4 className="text-sm font-medium text-gray-700 mb-3">Özel Renkler</h4>
        <div className="space-y-3">
          {Object.entries(colors).map(([key, value]) => (
            <div key={key} className="flex items-center justify-between">
              <label className="text-sm text-gray-600">
                {colorLabels[key as keyof typeof colorLabels]}
              </label>
              <div className="flex items-center gap-2">
                <button
                  onClick={() => setActiveColor(activeColor === key ? null : key as keyof typeof colors)}
                  className="w-10 h-10 rounded-lg border-2 border-gray-300 hover:border-primary-500 transition-colors relative"
                  style={{ backgroundColor: value }}
                >
                  {activeColor === key && (
                    <div className="absolute inset-0 flex items-center justify-center bg-black bg-opacity-30 rounded-lg">
                      <X className="h-4 w-4 text-white" />
                    </div>
                  )}
                </button>
                <input
                  type="text"
                  value={value.toUpperCase()}
                  readOnly
                  className="w-20 px-2 py-1 text-xs border border-gray-300 rounded text-center font-mono"
                />
              </div>
            </div>
          ))}
        </div>

        {/* Color Picker Modal */}
        {activeColor && (
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4" style={{ backgroundColor: 'rgba(0, 0, 0, 0.5)' }}>
            {/* Backdrop */}
            <div className="absolute inset-0" onClick={() => setActiveColor(null)} />
            
            {/* Picker Container */}
            <div className="relative bg-white rounded-lg shadow-2xl p-4">
              <div className="flex items-center justify-between mb-3">
                <h4 className="font-medium text-gray-900">
                  {colorLabels[activeColor as keyof typeof colorLabels]} Seçin
                </h4>
                <button
                  onClick={() => setActiveColor(null)}
                  className="p-1 text-gray-400 hover:text-gray-600 rounded"
                >
                  <X className="h-5 w-5" />
                </button>
              </div>
              {/* @ts-ignore - react-color SketchPicker type issue */}
              <SketchPicker
                color={colors[activeColor]}
                onChange={handleColorChange}
                disableAlpha
              />
            </div>
          </div>
        )}
      </div>

    </div>
  );
};

export default ColorPicker;
