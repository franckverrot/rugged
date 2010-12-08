require File.expand_path "../test_helper", __FILE__

context "Rugged::Backend stuff" do

  class TestBackend < Rugged::Backend
    def read(oid)
      pp "Trying to read ", oid
      nil
    end

    def exists(oid)
      pp "Rugged::Backend: Trying to exist ", oid
      false
    end
  end

  setup do
    @path = File.dirname(__FILE__) + '/fixtures/testrepo.git/'
    @repo = Rugged::Repository.new(@path)
    @blob_sha = "fa49b077972391ad58037050f2a75f74e3671e92"
  end

  test "can add a new backend" do
    backend = TestBackend.new(5) # max priority
    @repo.add_backend(backend)
    @repo.lookup(@blob_sha)
    #@repo.exists(@blob_sha)
    @repo.read(@blob_sha)
  end
end
