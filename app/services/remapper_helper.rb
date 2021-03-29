module RemapperHelper
  module_function

  def valid?(movement: nil, mapping: nil)
    return false if mapping.blank? || movement.blank?

    current_content = movement.public_send(mapping.field_to_watch).to_s.downcase
    text_to_match = mapping.text_to_match.downcase

    case mapping.kind_of_match
    when KindOfMatch::CONTAINS
      current_content.match(Regexp.new(text_to_match, Regexp::IGNORECASE))
    when KindOfMatch::EQUALS
      current_content == text_to_match
    when KindOfMatch::STARTS_WITH
      current_content.start_with?(text_to_match)
    when KindOfMatch::ENDS_WITH
      current_content.end_with?(text_to_match)
    else
      false
    end
  end

  def apply(movement: nil, mapping: nil)
    return if mapping.blank? || movement.blank?

    new_content = case mapping.kind_of_change
                  when KindOfChange::REPLACE
                    mapping.text_to_change
                  when KindOfChange::PREPEND
                    current_content = movement.public_send(mapping.field_to_change)
                    "#{mapping.text_to_change}#{current_content}"
                  when KindOfChange::APPEND
                    current_content = movement.public_send(mapping.field_to_change)
                    "#{current_content}#{mapping.text_to_change}"
                  end

    movement.public_send("#{mapping.field_to_change}=", new_content)
  end
end
