module Tilia
  module Dav
    module Mock
      # Mock Streaming File File
      #
      # Works similar to the mock file, but this one works with streams and has no
      # content-length or etags.
      class StreamingFile < File
        # Updates the data
        #
        # The data argument is a readable stream resource.
        #
        # After a succesful put operation, you may choose to return an ETag. The
        # etag must always be surrounded by double-quotes. These quotes must
        # appear in the actual string you're returning.
        #
        # Clients may use the ETag from a PUT request to later on make sure that
        # when they update the file, the contents haven't changed in the mean
        # time.
        #
        # If you don't plan to store the file byte-by-byte, and you return a
        # different object on a subsequent GET you are strongly recommended to not
        # return an ETag, and just return null.
        #
        # @param resource data
        # @return string|null
        def put(data)
          if data.is_a?(String)
            stream = StringIO.new
            stream.write(data)
            stream.rewind
            data = stream
          end
          @contents = data
        end

        # Returns the data
        #
        # This method may either return a string or a readable stream resource
        #
        # @return mixed
        def get
          @contents
        end

        # Returns the ETag for a file
        #
        # An ETag is a unique identifier representing the current version of the file. If the file changes, the ETag MUST change.
        #
        # Return null if the ETag can not effectively be determined
        #
        # @return void
        def etag
          nil
        end

        # Returns the size of the node, in bytes
        #
        # @return int
        attr_accessor :size
      end
    end
  end
end
