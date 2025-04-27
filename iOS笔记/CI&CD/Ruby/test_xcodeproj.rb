# Coder Runner Extension

# gem env
# https://www.rubydoc.info/gems/xcodeproj/Xcodeproj/
require 'xcodeproj'

def debugXcodeproject()
puts '=====start debugXcodeproject====='
# 当前路径
base_path = File.dirname(__FILE__)
puts 'base_path = ' + base_path
pod_project_path = base_path + '/Pods/Pods.xcodeproj'
pod_project = Xcodeproj::Project.open(pod_project_path)
pod_target = nil
pod_project.targets.each_with_index do |target, index|
    puts "target = #{target}, index = #{index}"
    if target.name  == "Pods-HDXcodeProjDemo"
        pod_target = target
    end
end
puts "dependencies = #{pod_target.dependencies}"

puts '=====end debugXcodeproject====='
end

debugXcodeproject()