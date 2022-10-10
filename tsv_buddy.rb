# frozen_string_literal: true

# Module that can be included (mixin) to take and output TSV data
# replace magic strings
TAB = "\t"
NEWLINE = "\n"

# tsv buddy mpodule
module TsvBuddy
  # take_tsv: converts a String with TSV data into @data
  # parameter: tsv - a String in TSV format
  def get_headers(array)
    heading = array.first.split(TAB)
    heading.map(&:chomp)
  end

  def hash_data(file_headings, remaining_data)
    hash_of_data = {}
    file_headings.each_index do |index|
      hash_of_data[file_headings[index]] = remaining_data[index]
    end
    hash_of_data
  end

  def array_hash(array, file_heading, arr_hashes)
    array.each do |remaining_lines|
      final_lines = remaining_lines.split(TAB)
      arr_hashes.push(hash_data(file_heading, final_lines))
    end
    arr_hashes
  end

  def take_tsv(tsv)
    arr_contains_lines = tsv.split(NEWLINE)
    heading_keys = get_headers(arr_contains_lines)
    arr_contains_lines = arr_contains_lines[1..]
    array_hash(arr_contains_lines, heading_keys, @data = [])
  end

  # to_tsv: converts @data into tsv string
  # returns: String in TSV format
  def keys
    data.first.keys
  end

  def split_then_add
    headers = [keys]
    values = data.map(&:values)
    headers + values
  end

  def to_tsv
    tsv_strings = split_then_add
    tsv_strings = tsv_strings.map do |lines|
      lines.join(TAB) + NEWLINE
    end

    # keep string
    tsv_strings.join('')
  end
end
