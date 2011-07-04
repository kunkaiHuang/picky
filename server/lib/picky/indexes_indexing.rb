# Indexes indexing.
#
class Indexes

  instance_delegate :take_snapshot,
                    :generate_caches,
                    :backup_caches,
                    :restore_caches,
                    :check_caches,
                    :clear_caches,
                    :create_directory_structure,
                    :index,
                    :index_for_tests

  each_delegate :take_snapshot,
                :generate_caches,
                :backup_caches,
                :restore_caches,
                :check_caches,
                :clear_caches,
                :create_directory_structure,
                :to => :indexes

  # Runs the indexers in parallel (prepare + cache).
  #
  def index randomly = true
    take_snapshot

    # Run in parallel.
    #
    timed_exclaim "Indexing using #{Cores.max_processors} processors, in #{randomly ? 'random' : 'given'} order."

    # Run indexing/caching forked.
    #
    Cores.forked self.indexes, { randomly: randomly }, &:index

    timed_exclaim "Indexing finished."
  end

  # For integration testing – indexes for the tests
  # without forking and shouting ;)
  #
  def index_for_tests
    take_snapshot

    indexes.each(&:index)
  end

end