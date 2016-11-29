require 'json'
#pushnode(i,"HOST",false,node)
#pushnode(i,"EDGE",true,node)
#pushedge(i-1,i%11,edge)
#module View
  # Topology controller's GUI (graphviz).
  class Html
    def initialize(output = 'topology.html')
      @nodes=[]
      @edges=[]
      @output = output
    end

    # rubocop:disable AbcSize
    #def update(_event, _changed, topology)
    def update(graph,allgraph)
      @nodes=[]
      @edges=[]
      pastnode=nil
      pastedge={}
 

  #    @all = allgraph.map { |name, neighbors| Node.new(name, neighbors) }	#All nodes    
      graph.each do |key,value| 
	puts key
	if key.to_s[2]==':' then
	  currentnode=key.to_s
	  #currentnode=value.to_s
	  pushnode(currentnode,true)
	else
	  currentnode=key.to_s[2]
	 # currentnode=value.to_s
	  pushnode(currentnode,false)
	end
 #       pushnode(value,false)
      #topology.hosts.each_with_object([]) do |each|
	#pushnode(each.to_s,true)
      #end 
        if  pastnode!=currentnode then
	  if pastnode.to_i > currentnode.to_i then
            pushedge(currentnode,pastnode,true)
	    pastedge[currentnode]=pastnode
	  else
	    pushedge(pastnode,currentnode,true)
	    pastedge[pastnode]=currentnode
	  end
        end
        pastnode = currentnode
        end

        for node in allgraph do
  	  if node.name.to_s[2]==':'then
  	     pushnode(node.name.to_s,true)
          else
	    pushnode(node.name.to_s[2],false)
	  end
	  node.neighbors.each do |value|
	    if node.neighbors[2]!=':' then
		a = node.name.to_s[2]
		b = value.to_s[2]
		if a.to_i > b.to_i then
		  a,b=b,a
		end
	    #finded=@edges.find{|item|
	    #((item['from'].to_s==node.name.to_s[2] and item['to'].to_s==value.to_s[2]) or (item['to'].to_s==node.name.to_s[2] and item['from'].to_s==value.to_s[2]))
  	    #}
	      if not((pastedge[a]==b) || (pastedge[b]==a))  then
	        pushedge(a,b,false)
              end
	    end
	end
	


      end



      #topology.hslinks.each do |each|
#	pushedge(each.mac_address.to_s,each.dpid)
 #     end
      @nodes = @nodes.uniq
      @edges = @edges.uniq
      output()
    end
  private
  def output()
    base =File.read("./lib/view/create_vis_base.txt")
    base2 =File.read("./lib/view/create_vis_base2.txt")
    result= base+JSON.generate(@nodes)+";\n edges ="+JSON.generate(@edges)+base2
    File.write(@output, result)
  end
  def pushnode(id,ishost)
    if id.nil? then
	return
    end
    if ishost then
      @nodes.push({id:id,label:id,image:"./lib/view/laptop.png",shape:'image'}) 
    else
      @nodes.push({id:id,label:id,image:"./lib/view/switch.png",shape:"image"})
    end
  end
  def pushedge(from,to,isselected)
    if from.nil? or to.nil? or from=='null' or to=='null' or from==':'or to==':' then
	return
    end
    if isselected==true then
      @edges.push({from:from,to:to,color:{color:"red"}})
    else
      @edges.push({from:from,to:to,color:{color:"blue"}})
    end
  end
  end

