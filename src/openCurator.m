function openCurator()
sa_labs.analysis.ui.util.addJavaJars({'UIExtrasComboBox.jar', 'UIExtrasTable.jar', 'UIExtrasTable2.jar', 'UIExtrasTree.jar', 'UIExtrasPropertyGrid.jar'});
manager = getAnalysisManager();
fileRepository = getFileRepository();
p = sa_labs.analysis.ui.presenters.DataCuratorPresenter(manager, fileRepository);
p.go();
end

