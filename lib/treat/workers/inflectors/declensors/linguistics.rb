# Inflection using the the 'linguistics' gem (will attempt
# to load the Linguistics module corresponding to the
# language of the entity.
#
# Website: http://deveiate.org/projects/Linguistics/
class Treat::Workers::Inflectors::Declensors::Linguistics

  # Part of speech that can be declensed.
  POS = ['noun', 'adjective', 'determiner']
  
  # Retrieve a declension of a word using the 'linguistics' gem.
  #
  # Options:
  #
  # - (Identifier) :count => :singular, :plural
  def self.declense(entity, options = {})

    cat = entity.get(:category)
    return if cat && !POS.include?(cat)
    unless options[:count]
      raise Treat::Exception, 'Must supply ' +
      ':count option ("singular" or "plural").'
    end
    
    klass = Treat::Loaders::
    Linguistics.load(entity.language)
    string = entity.to_s

    if options[:count].to_s == 'plural'
      if (entity.has?(:category))
        result = ''
        silence_warnings do
          result = klass.send(
          :"plural_#{entity.category}",
          string)
        end
        return result
      else
        return klass.plural(string)
      end

    else
      raise Treat::Exception,
      "Ruby Linguistics does not support " +
      "singularization of words."
    end

  end

end
