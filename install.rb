class Swiftplate < Formula
  desc "Cross-platform Swift framework templates from the command-line"
  homepage "https://github.com/JohnSundell/SwiftPlate"
  url "https://github.com/JohnSundell/SwiftPlate/archive/1.2.0.tar.gz",
    :tag => "1.2.0"
  sha256 "1d9f76afc0a7b18287d05801319f40c6b19df0c811841901630ff9c09f115d98"
  head "https://github.com/JohnSundell/SwiftPlate.git"
  depends_on :xcode => "8.2"

  def install
    system "make", "install"
  end

  test do
    system "#{bin}/swiftlint", "--destination", ".", "--projectname", "testProject", "", "--authorname", "testUser", "--authoremail", "test@example.com", "--githuburl", "https://github.com/johnsundell/swiftplate", "--organizationname", "exampleOrg"

    (testpath/"test.py").write <<-EOS.undent
        # -*- coding: utf-8 -*-
        import sys
        import os
        from os.path import join, getsize

        rootFiles = set(['LICENSE', 'Package.swift', 'README.md', sys.argv[1] + '.podspec'])
        configFiles = set([sys.argv[1] + '.plist', sys.argv[1] + 'Tests.plist'])
        sourceFiles = set([sys.argv[1]+ '.swift'])
        testDirs = set([sys.argv[1] + 'Tests'])

        for root, dirs, files in os.walk('.'):
            if root == '.':
                if sys.argv[1] + '.xcodeproj' not in dirs:
                    print("xcode project not found")
                    exit(1)
                if not rootFiles.issubset(files):
                    print("root level files not found")
                    exit(1)
            if root == './Configs':
                if not configFiles.issubset(files):
                    print("Config files not found")
                    exit(1)
            if root == './Sources':
                if not sourceFiles.issubset(files):
                    print("Source files not found")
                    exit(1)
            if root == './Tests':
                if not testDirs.issubset(dirs):
                    print("Test Directories not found")
                    exit(1)
        print("All tests run successfully ⭐⭐⭐⭐⭐")
        exit(0)
    EOS
    system "python", "test.py", "testProject"
  end
end
