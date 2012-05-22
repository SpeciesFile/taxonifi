module Taxonifi

  class CollectionError < StandardError; end

  module Model

    class Collection
      attr_accessor :by_id_index
      attr_accessor :current_free_id
      attr_accessor :collection 

      def initialize(options = {})
        opts = {
          :initial_id => 0
        }.merge!(options)
        @collection = []
        @by_id_index = {} 
        @current_free_id = opts[:initial_id]
        true
      end 

      def object_class
        Taxonifi::Model::GenericObject
      end

      def object_by_id(id)
        @by_id_index[id] 
      end

      def add_object(obj)
        raise CollectionError, "Taxonifi::Model::#{object_class.class}#id may not be pre-initialized if used with #add_object, consider using #add_object_pre_indexed." if !obj.id.nil?
        object_is_allowed?(obj)
        obj.id = @current_free_id.to_i
        @current_free_id += 1
        @collection.push(obj)
        @by_id_index.merge!(obj.id => obj) 
        return obj
      end

      def add_object_pre_indexed(obj)
        object_is_allowed?(obj)
        raise CollectionError, "Taxonifi::Model::#{object_class.class} does not have a pre-indexed id." if obj.id.nil?
        @collection.push(obj)
        @by_id_index.merge!(obj.id => obj)
        return obj
      end

      # TODO: deprecate?
      # More or less identical to Taxonifi::Name.ancestor_ids except
      # this checks against the indexed names in the collection
      # rather than Name->Name relationships
      # The two should be identical in all(?) conievable cases
      def parent_id_vector(id = Fixnum)
        vector = []
        return vector if @by_id_index[id].nil? || @by_id_index[id].parent.nil?
        id = @by_id_index[id].parent.id
        while !id.nil?
          vector.unshift id
          if @by_id_index[id].parent
            id = @by_id_index[id].parent.id 
          else
            id = nil
          end
        end
        vector
      end

      # Returns an Array which respresents
      # all the "root" objects
      def objects_without_parents
        collection.select{|o| o.parent.nil?}
      end

      protected

      def object_is_allowed?(obj)
        raise CollectionError, "Taxonifi::Model::#{object_class.class} not passed to Collection.add_object()." if !(obj.class == object_class)
        true
      end

    end
  end

end
