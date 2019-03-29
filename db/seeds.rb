puts "Creating custom files..."
CustomFile.create(name: "file1", tags: [:tag1, :tag2, :tag3, :tag5])
CustomFile.create(name: "file2", tags: [:tag2])
CustomFile.create(name: "file3", tags: [:tag2, :tag3, :tag5])
CustomFile.create(name: "file4", tags: [:tag2, :tag3, :tag4, :tag5])
CustomFile.create(name: "file5", tags: [:tag3, :tag4])
puts "Finished."