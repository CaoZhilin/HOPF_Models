function [ ground_truth,raw_data,position_map ] = load_data( groundtruth, rawdata, posmap )
%LOAD_DATA 
%   raw_data: features
ground_truth = groundtruth;
raw_data = rawdata;
position_map = posmap;
end

%
%             raw_data : ndarray, (n_samples, n_features)
%             ground_truth : ndarray, (n_samples,).{0...K-1} labels.
%         """
%         if not raw_data is None:
%             self.nclass = None # reset number of classes
%             self.graph = BuildGraph() # reset the graph every time new data is loaded 
%             self.data.raw_data = raw_data
%             if hasattr(self,'fid'):
%                 self.fid = None
%         if not ground_truth is None:
%             # infer the label from ground_truth if available. 
%             self.nclass = None #reset the number of classes
%             self.n_class = np.unique(ground_truth).shape[0] 
%             if np.unique(ground_truth).shape[0] == 2 :# convert labels binary case
%                 self.data.ground_truth = util.to_binary_labels(ground_truth)
%             else:
%                 self.data.ground_truth = util.to_standard_labels(ground_truth)
%             if hasattr(self,'fid'): #reset fidelity after loading ground_truth
%                 self.fid = None       