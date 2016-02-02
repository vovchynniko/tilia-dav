module Tilia
  module Dav
    module PropertyStorage
      module Backend
        class Mock
          include BackendInterface

          attr_accessor :data

          def initialize
            @data = {}
          end

          # Fetches properties for a path.
          #
          # This method received a PropFind object, which contains all the
          # information about the properties that need to be fetched.
          #
          # Ususually you would just want to call 'get404Properties' on this object,
          # as this will give you the _exact_ list of properties that need to be
          # fetched, and haven't yet.
          #
          # @param string path
          # @param PropFind prop_find
          # @return void
          def prop_find(path, prop_find)
            return nil unless @data.key?(path)

            @data[path].each do |name, value|
              prop_find.set(name, value)
            end
          end

          # Updates properties for a path
          #
          # This method received a PropPatch object, which contains all the
          # information about the update.
          #
          # Usually you would want to call 'handleRemaining' on this object, to get
          # a list of all properties that need to be stored.
          #
          # @param string path
          # @param PropPatch prop_patch
          # @return void
          def prop_patch(path, prop_patch)
            @data[path] = {} unless @data.key?(path)

            prop_patch.handle_remaining(
              lambda do |properties|
                properties.each do |prop_name, prop_value|
                  if prop_value.nil?
                    @data[path].delete(prop_name)
                  else
                    @data[path][prop_name] = prop_value
                  end
                  return true
                end
              end
            )
          end

          # This method is called after a node is deleted.
          #
          # This allows a backend to clean up all associated properties.
          def delete(path)
            @data.delete(path)
          end

          # This method is called after a successful MOVE
          #
          # This should be used to migrate all properties from one path to another.
          # Note that entire collections may be moved, so ensure that all properties
          # for children are also moved along.
          #
          # @param string source
          # @param string destination
          # @return void
          def move(source, destination)
            @data.each do |path, props|
              if path == source
                @data[destination] = props
                @data.delete(path)
                next
              end

              if path.index("#{source}/") == 0
                @data["#{destination}#{path[source.length + 1..-1]}"] = props
                @data.delete(path)
              end
            end
          end
        end
      end
    end
  end
end