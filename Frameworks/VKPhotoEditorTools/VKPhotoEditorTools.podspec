Pod::Spec.new do |s|
  s.name = "VKPhotoEditorTools"
  s.version = "1.0"
  s.summary = "Модуль вспомогательных классов"

  s.platform = :ios, "13.0"
  s.swift_version = '5.0'

  s.author = { 'Timur Shafigullin' => 'hometim55@gmail.com' }
  s.homepage = 'https://github.com/timbaev'
  s.source = { :git => 'https://github.com/timbaev/vk-photo-editor.git', :tag => s.version.to_s }

  s.license = { 
    :type => 'MIT', 
    :text => <<-LICENSE
       Copyright 2020
       Permission is granted to VKPhotoEditor
             LICENSE
  }

  s.source_files = [
    '**/*.{swift,h,m,xib,storyboard}'
  ]

  s.exclude_files = [
    '**/*Tests.swift',
  ]

  s.resources = [
    "Resources/**/*"
  ]
end
